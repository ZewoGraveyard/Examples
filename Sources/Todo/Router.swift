import HTTP
import Router
import Middleware
import Sideburns

let router = Router { route in
    route.router("/api", APIv1 >>> log)
    route.router("/api", APIv2 >>> log)

    route.get("/todos") { _ in
    	let templateData: TemplateData = todoResources.todos.all.map { todo in
    		todo.description
    	}
    	return try Response(status: .OK, templatePath: "Resources/todos.mustache", templateData: templateData)
    }

    let staticFiles = FileResponder(basePath: "Resources/")
    route.fallback(staticFiles)
} 
