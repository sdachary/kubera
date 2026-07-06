import { application } from "controllers/application"
import ChatController from "controllers/chat_controller"
import ChatFormController from "controllers/chat_form_controller"
import ClipboardController from "controllers/clipboard_controller"
import StatsController from "controllers/stats_controller"
import ConversationsController from "controllers/conversations_controller"
import PrivacySettingsController from "controllers/privacy_settings_controller"

application.register("chat", ChatController)
application.register("chat-form", ChatFormController)
application.register("clipboard", ClipboardController)
application.register("stats", StatsController)
application.register("conversations", ConversationsController)
application.register("privacy-settings", PrivacySettingsController)
