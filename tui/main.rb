#!/usr/bin/env ruby
require 'tty-prompt'
require 'tty-table'
require 'pastel'
require 'yaml'

pastel = Pastel.new
prompt = TTY::Prompt.new

def system_check
    checks = {
        ruby: `which ruby`.strip.empty? ? "❌" : "✅",
        git: `which git`.strip.empty? ? "❌" : "✅",
        docker: `which docker`.strip.empty? ? "❌" : "✅",
        node: `which node`.strip.empty? ? "❌" : "✅"
    }
    checks
end

def run_cmd(cmd)
    system(cmd, out: File::NULL, err: File::NULL)
end

puts pastel.cyan.bold("╔══════════════════════════════════════╗")
puts pastel.cyan.bold("║          KUBERA SETUP TUI           ║")
puts pastel.cyan.bold("╚══════════════════════════════════════╝")

# Auto-clone backend if missing
backend_dir = "#{Dir.pwd}/backend"
unless Dir.exist?(backend_dir)
    puts pastel.yellow("\n📥 Backend not found. Cloning automatically...")
    if run_cmd("git clone https://github.com/sdachary/kubera-backend.git #{backend_dir}")
        puts pastel.green("✅ Backend cloned to #{backend_dir}")
    else
        puts pastel.red("❌ Failed to clone backend. Please create sdachary/kubera-backend repo on GitHub first.")
        puts pastel.yellow("Run: gh repo create sdachary/kubera-backend --public")
        exit 1
    end
end

loop do
    system_check_result = system_check
    table = TTY::Table.new(header: ['Component', 'Status']) do |t|
        system_check_result.each { |k, v| t << [k.to_s, v] }
    end

    puts "\n" + table.render(:ascii)
    puts

    choice = prompt.select("What would you like to do?", symbols: { marker: '▶' }) do |menu|
        menu.choice pastel.green('🚀 Full Install & Start'), :install
        menu.choice pastel.blue('⚙️  Configure API Keys'), :config
        menu.choice pastel.yellow('🧪 Run Tests'), :test
        menu.choice pastel.magenta('📊 View Progress'), :progress
        menu.choice pastel.cyan('📦 Install Dependencies'), :deps
        menu.choice pastel.red('🛑 Stop Services'), :stop
        menu.choice pastel.white('❌ Exit'), :exit
    end

    case choice
    when :install
        puts pastel.yellow("\n🔧 Setting up database...")
        run_cmd("cd #{Dir.pwd}/backend && cp .env.local.example .env.local 2>/dev/null || true")
        run_cmd("cd #{Dir.pwd}/backend && bin/setup 2>&1 | tail -5")

        puts pastel.yellow("\n🔧 Starting services...")
        run_cmd("cd #{Dir.pwd}/backend && bin/dev &")

        puts pastel.green("\n✅ Kubera is running at http://localhost:3000")

    when :config
        puts pastel.blue("\n⚙️  API Key Configuration")
        keys = {
            openrouter: prompt.ask("OpenRouter API Key (for AI features)?", default: ENV['OPENROUTER_API_KEY'] || ''),
            supabase_url: prompt.ask("Supabase URL?", default: ''),
            supabase_key: prompt.ask("Supabase Key?", default: '', echo: false)
        }
        env_content = keys.map { |k, v| "#{k.to_s.upcase}=#{v}" }.join("\n")
        File.write("#{Dir.pwd}/backend/.env.local", env_content)
        puts pastel.green("✅ Saved to backend/.env.local")

    when :test
        puts pastel.yellow("\n🧪 Running test suite...")
        run_cmd("cd #{Dir.pwd}/backend && bin/rails test 2>&1 | tail -10")
        prompt.keypress(pastel.cyan("\nPress any key to continue..."))

    when :progress
        if File.exist?("#{Dir.pwd}/PROGRESS.md")
            puts File.read("#{Dir.pwd}/PROGRESS.md")
        else
            puts pastel.red("No PROGRESS.md found")
        end
        prompt.keypress(pastel.cyan("\nPress any key to continue..."))

    when :deps
        puts pastel.yellow("\n📦 Installing Ruby gems...")
        run_cmd("cd #{Dir.pwd}/backend && bundle install 2>&1 | tail -5")
        puts pastel.yellow("\n📦 Installing Node packages...")
        run_cmd("cd #{Dir.pwd}/backend && npm install 2>&1 | tail -5")
        puts pastel.green("✅ Dependencies installed")

    when :stop
        puts pastel.red("\n🛑 Stopping services...")
        run_cmd("pkill -f 'rails server' || true")
        run_cmd("pkill -f 'vite' || true")
        puts pastel.green("✅ Services stopped")

    when :exit
        puts pastel.cyan("\n👋 Goodbye!")
        exit 0
    end
end
