
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "2.0"

define_target "project" do |target|
	target.description = <<-EOF
		Generates a basic C++ project.
	EOF
	
	target.depends "Generate/Copy"
	target.provides "Generate/Initial"
	
	target.build do |project_name|
		source_path = Build::Files::Directory.new(target.package.path + "templates/project")
		substitutions = target.context.substitutions.dup
		
		name = Build::Name.new(project_name)
		
		# e.g. Foo Bar, typically used as a title, directory, etc.
		substitutions['PROJECT_NAME'] = name.text
		
		# e.g. FooBar, typically used as a namespace
		substitutions['PROJECT_IDENTIFIER'] = name.identifier
		
		# e.g. foo-bar, typically used for targets, executables
		substitutions['PROJECT_TARGET_NAME'] = name.target
		
		generate source: source_path, prefix: target.context.root, substitutions: substitutions
	end
end

define_configuration "project" do |configuration|
	configuration.public!
	
	configuration.require 'generators'
end
