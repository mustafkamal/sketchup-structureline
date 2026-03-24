require 'json'
require 'fileutils'

# Paths
SRC_DIR   = "src"
DIST_DIR  = "dist"
RUBY_DIR = File.join(SRC_DIR, "mustafa_structureline", "ruby")
REGISTRAR_FILE = File.join(SRC_DIR, "mustafa_structureline.rb")
MANIFEST_FILE = File.join(DIST_DIR, "manifest.json")
EXTENSION_FILE = File.join(RUBY_DIR, "extension.rb")
PACKAGE   = File.join(DIST_DIR, "mustafa_structureline.rbz")

desc "Apply metadata in manifest.json to the registrar and extension files"
task :apply_manifest do
  manifest = JSON.parse(File.read(MANIFEST_FILE))
  registrar = File.read(REGISTRAR_FILE)
  extension = File.read(EXTENSION_FILE)
  warning_tag = '## /!\\ Auto-generated line, do not edit ##'

  registrar.gsub!(/ex\.creator\s*=.*/,
                  "ex.creator     = '#{manifest['creator']}' #{warning_tag}")

  registrar.gsub!(/ex\.description\s*=.*/,
                  "ex.description = '#{manifest['description']}' #{warning_tag}")

  registrar.gsub!(/ex\.version\s*=.*/,
                  "ex.version     = '#{manifest['version']}' #{warning_tag}")

  registrar.gsub!(/ex\.copyright\s*=.*/,
                  "ex.copyright   = \"#{manifest['copyright']}\" #{warning_tag}")

  extension.gsub!(/VERSION\s*=.*/,
                  "VERSION   = '#{manifest['version']}' #{warning_tag}")

  File.write(REGISTRAR_FILE, registrar)
  File.write(EXTENSION_FILE, extension)
  puts "Registrar and extension files are updated."
end

desc "Build RBZ package"
task :build => [:update_registrar] do
  FileUtils.mkdir_p(DIST_DIR)
  FileUtils.rm_f(PACKAGE)

  Dir.chdir(SRC_DIR) do
    files = Dir.glob("**/*")
    system("zip -r ../#{PACKAGE} #{files.join(' ')}")
  end

  puts "Built package: #{PACKAGE}"
end