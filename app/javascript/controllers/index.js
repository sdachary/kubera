import { application } from "./application"
import ChatController from "./chat_controller"
import ChatFormController from "./chat_form_controller"
import ClipboardController from "./clipboard_controller"
import StatsController from "./stats_controller"
import ConversationsController from "./conversations_controller"
import PrivacySettingsController from "./privacy_settings_controller"

application.register("chat", ChatController)
application.register("chat-form", ChatFormController)
application.register("clipboard", ClipboardController)
application.register("stats", StatsController)
application.register("conversations", ConversationsController)
application.register("privacy-settings", PrivacySettingsController)
