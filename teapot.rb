
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_generator "project" do |generator|
	generator.description = <<-EOF
		Generates a basic project for use with the dream-framework.
	EOF
	
	generator.generate do |project_name|
		source_path = Pathname("source/#{project_name}")
		test_path = Pathname("test/")
		
		name = Name.new(project_name)
		substitutions = Substitutions.new
		
		# e.g. Foo Bar, typically used as a title, directory, etc.
		substitutions['PROJECT_NAME'] = name.text
		
		# e.g. FooBar, typically used as a namespace
		substitutions['PROJECT_IDENTIFIER'] = name.identifier
		
		# e.g. foo-bar, typically used for targets, executables
		substitutions['PROJECT_TARGET_NAME'] = name.target
		
		# The user's current name:
		current_date = Time.new
		substitutions['DATE'] = current_date.strftime("%-d/%-m/%Y")
		substitutions['YEAR'] = current_date.strftime("%Y")
		substitutions['AUTHOR_NAME'] = `git config --global user.name`.chomp!
		
		generator.copy('templates/project', '.', substitutions)
	end
end

def scope_for_namespace(namespace)
	open = namespace.collect{|name| "namespace #{name}\n{\n"}
	close = namespace.collect{ "}\n" }
	
	return open + close
end

define_generator "class" do |generator|
	generator.description = <<-EOF
		Generates a basic class file in the project.
	EOF
	
	generator.generate do |class_name|
		*path, class_name = class_name.split(/::/)
		
		directory = Pathname('source') + path.join('/')
		directory.mkpath
		
		name = Name.new(class_name)
		substitutions = Substitutions.new
		
		# e.g. Foo Bar, typically used as a title, directory, etc.
		substitutions['CLASS_NAME'] = name.identifier
		substitutions['CLASS_FILE_NAME'] = name.identifier
		
		# e.g. FooBar, typically used as a namespace
		substitutions['GUARD_NAME'] = name.macro + '_H'
		
		# e.g. foo-bar, typically used for targets, executables
		substitutions['NAMESPACE'] = scope_for_namespace(path)
		
		# The user's current name:
		substitutions['AUTHOR_NAME'] = `git config --global user.name`.chomp!
		
		if ENV.key?('PROJECT_NAME')
			# It would be nice if this was saved somewhere:
			substitutions['PROJECT_NAME'] = ENV['PROJECT_NAME']
		end
		
		substitutions['LICENSE'] = ENV['LICENSE'] || 'MIT License'
		
		current_date = Time.new
		substitutions['DATE'] = current_date.strftime("%-d/%-m/%Y")
		substitutions['YEAR'] = current_date.strftime("%Y")
		
		generator.copy('templates/class', directory, substitutions)
	end
end

define_generator "xcode-config" do |generator|
	generator.generate do |*dependency_names|
		chain = context.dependency_chain(dependency_names)
		ordered = context.direct_targets(chain.ordered)
		
		environment = ordered.last[0].build_environment(context.configuration)
		
		substitutions = Substitutions.new
		
		environment.flatten.each do |key, value|
			if Array === value
				value = value.collect{|value| value.to_s}.join(" ")
			end
			
			puts "TEAPOT_#{key.upcase} => #{value}"
			substitutions["TEAPOT_#{key.upcase}"] = value.to_s
		end
		
		substitutions["CONFIGURATION_NAME"] = context.configuration.name

		generator.copy('templates/xcode-config', '.', substitutions)
	end
end

define_configuration "project" do |configuration|
	configuration.public!

	configuration.import 'dream-framework'
end

define_configuration "dream-framework" do |configuration|
	configuration.public!

	configuration.import! "platforms"

	configuration.require "png"
	configuration.require "jpeg"
	
	configuration.require "freetype"
	
	configuration.require "ogg"
	configuration.require "vorbis"

	# Unit testing
	configuration.require "unit-test"
	
	configuration.require "euclid"
	
	configuration.require "dream"
end
