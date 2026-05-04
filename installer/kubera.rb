#!/usr/bin/env ruby
require 'fileutils'

INSTALL_DIR = File.expand_path("~/kubera")
puts "Kubera Installer v0.3"
puts "Installing to: #{INSTALL_DIR}"
puts

FileUtils.mkdir_p(INSTALL_DIR)
Dir.chdir(INSTALL_DIR)

puts "Cloning Sure repo..."
system("git clone --depth 1 https://github.com/we-promise/sure.git sure")

puts "Creating .env.local..."
File.open("sure/.env.local", "w") do |f|
  f.write("OPENROUTER_API_KEY=\n")
  f.write("DATABASE_URL=postgresql://localhost/kubera_development\n")
end

puts
puts "Installation complete!"
puts "Location: #{INSTALL_DIR}"
puts
puts "Next steps:"
puts "  cd #{INSTALL_DIR}/sure"
puts "  bundle install && npm install"
puts "  bin/setup"
puts "  bin/dev"
puts "  Visit: http://localhost:3000"
