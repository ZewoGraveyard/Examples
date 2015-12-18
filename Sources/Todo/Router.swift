import HTTP
import Router
import Middleware
import Sideburns

let router = Router { route in
    route.router("/api", APIv1)
    route.router("/api", APIv2)

    route.get("/todos") { _ in
    	let templateData: TemplateData = todoResources.todos.all.map { todo in
    		todo.description
    	}
    	return try Response(status: .OK, templatePath: "Resources/todos.mustache", templateData: templateData)
    }
} >>> log
