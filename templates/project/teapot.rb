
# Project Metadata

define_project '$PROJECT_TARGET_NAME' do |project|
	project.title = '$PROJECT_NAME'
	project.summary = 'A brief one line summary of the project.'
	
	project.description = <<-EOF
		$PROJECT_NAME description.
	EOF
	
	project.license = 'MIT License'
	
	project.add_author '$AUTHOR_NAME', email: '$AUTHOR_EMAIL'
	# project.website = 'http://$PROJECT_IDENTIFIER.com/'
	
	project.version = '0.1.0'
end

# Build Targets

define_target '$PROJECT_TARGET_NAME-library' do |target|
	target.build do
		source_root = target.package.path + 'source'
		copy headers: source_root.glob('$PROJECT_IDENTIFIER/**/*.{h,hpp}')
		build static_library: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER/**/*.cpp')
	end
	
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends :platform
	target.depends 'Language/C++14', private: true
	
	target.provides 'Library/$PROJECT_IDENTIFIER' do
		append linkflags [
			->{install_prefix + 'lib/lib$PROJECT_IDENTIFIER.a'},
		]
	end
end

define_target '$PROJECT_TARGET_NAME-test' do |target|
	target.build do |*arguments|
		test_root = target.package.path + 'test'
		
		run tests: '$PROJECT_IDENTIFIER', source_files: test_root.glob('$PROJECT_IDENTIFIER/**/*.cpp'), arguments: arguments
	end
	
	target.depends 'Library/UnitTest'
	target.depends 'Library/$PROJECT_IDENTIFIER'

	target.provides 'Test/$PROJECT_IDENTIFIER'
end

# Configurations

define_configuration 'development' do |configuration|
	configuration.import '$PROJECT_TARGET_NAME'
	
	# Provides all the build related infrastructure:
	configuration.require 'platforms'
	
	# Provides unit testing infrastructure and generators:
	configuration.require 'unit-test'
	
	# Provides some useful C++ generators:
	configuration.require 'generate-cpp-class'
	
	configuration.require 'generate-project'
end

define_configuration '$PROJECT_TARGET_NAME' do |configuration|
	configuration.public!
end
