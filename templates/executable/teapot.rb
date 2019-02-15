
# Build Targets

define_target '$PROJECT_TARGET_NAME-library' do |target|
	target.depends 'Language/C++14'
	
	target.provides 'Library/$PROJECT_IDENTIFIER' do
		source_root = target.package.path + 'source'
		
		library_path = build static_library: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER/**/*.cpp')
		
		append linkflags library_path
		append header_search_paths source_root
	end
end

define_target '$PROJECT_TARGET_NAME-test' do |target|
	target.depends 'Library/$PROJECT_IDENTIFIER'
	target.depends 'Library/UnitTest'
	
	target.depends 'Language/C++14'
	
	target.provides 'Test/$PROJECT_IDENTIFIER' do |arguments|
		test_root = target.package.path + 'test'
		
		run tests: '$PROJECT_IDENTIFIER', source_files: test_root.glob('$PROJECT_IDENTIFIER/**/*.cpp'), arguments: arguments
	end
end

define_target '$PROJECT_TARGET_NAME-executable' do |target|
	target.depends 'Library/$PROJECT_IDENTIFIER'
	
	target.depends 'Language/C++14'
	
	target.provides 'Executable/$PROJECT_IDENTIFIER' do
		source_root = target.package.path + 'source'
		
		build executable: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER.cpp')
	end
end

define_target '$PROJECT_TARGET_NAME-run' do |target|
	target.depends 'Executable/$PROJECT_IDENTIFIER'
	
	target.provides 'Run/$PROJECT_IDENTIFIER' do |arguments|
		run executable: '$PROJECT_IDENTIFIER', arguments: arguments
	end
end

# Configurations
