import Vapor
import Leaf
import FluentMySQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(LeafProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Register Leaf Renderers
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    // Configure MySQL
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "root"
    let password = Environment.get("DATABASE_PASSWORD") ?? "root"
    let databaseName = Environment.get("DATABASE_DB") ?? "myvapor"
    let databaseConfig = MySQLDatabaseConfig(
        hostname: hostname,
        port: 3306,
        username: username,
        password: password,
        database: databaseName
    )
    services.register(databaseConfig)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: TestModel.self, database: .mysql)
    services.register(migrations)
}
