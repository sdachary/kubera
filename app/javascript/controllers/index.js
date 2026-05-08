import { application } from "./application"
import ChatController from "./chat_controller"
import ChatFormController from "./chat_form_controller"
import StatsController from "./stats_controller"
import ConversationsController from "./conversations_controller"

application.register("chat", ChatController)
application.register("chat-form", ChatFormController)
application.register("stats", StatsController)
application.register("conversations", ConversationsController)
