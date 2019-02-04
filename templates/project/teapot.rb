
# Project Metadata

define_project '$PROJECT_TARGET_NAME' do |project|
	project.title = '$PROJECT_NAME'
	project.license = 'MIT License'
	
	project.add_author '$AUTHOR_NAME', email: '$AUTHOR_EMAIL'
	
	project.version = '0.1.0'
end

# Build Targets

define_target '$PROJECT_TARGET_NAME-library' do |target|
	source_root = target.package.path + 'source'
	
	target.build do
		build prefix: target.name, static_library: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER/**/*.cpp')
	end
	
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends :platform
	target.depends 'Language/C++14', private: true
	
	target.provides 'Library/$PROJECT_IDENTIFIER' do
		append linkflags [
			->{install_prefix + target.name + '$PROJECT_IDENTIFIER.a'},
		]
		
		append buildflags [
			"-I", source_root
		]
	end
end

define_target '$PROJECT_TARGET_NAME-test' do |target|
	target.build do |*arguments|
		test_root = target.package.path + 'test'
		
		run prefix: target.name, tests: '$PROJECT_IDENTIFIER', source_files: test_root.glob('$PROJECT_IDENTIFIER/**/*.cpp'), arguments: arguments
	end
	
	target.depends 'Library/UnitTest'
	target.depends 'Library/$PROJECT_IDENTIFIER'
	
	target.depends 'Language/C++14', private: true
	
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
