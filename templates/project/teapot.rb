
# Build Targets

define_target '$PROJECT_TARGET_NAME-library' do |target|
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends :platform
	target.depends 'Language/C++14', private: true
	
	target.provides 'Library/$PROJECT_IDENTIFIER' do
		source_root = target.package.path + 'source'
		
		library_path = build prefix: target.name, static_library: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER/**/*.cpp')
		
		append linkflags library_path
		append header_search_paths source_root
	end
end

define_target '$PROJECT_TARGET_NAME-test' do |target|
	target.depends 'Library/$PROJECT_IDENTIFIER'
	target.depends 'Library/UnitTest'
	
	target.depends 'Language/C++14', private: true
	
	target.provides 'Test/$PROJECT_IDENTIFIER' do |arguments|
		test_root = target.package.path + 'test'
		
		run prefix: target.name, tests: '$PROJECT_IDENTIFIER', source_files: test_root.glob('$PROJECT_IDENTIFIER/**/*.cpp'), arguments: arguments
	end
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
