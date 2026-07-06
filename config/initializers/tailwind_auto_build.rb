if Rails.env.development?
  css_path = Rails.root.join("app/assets/builds/tailwind.css")
  unless css_path.exist?
    puts "\e[33mTailwind CSS build not found. Running tailwindcss:build...\e[0m"
    system("cd #{Rails.root} && bundle exec rails tailwindcss:build")
  end
end
