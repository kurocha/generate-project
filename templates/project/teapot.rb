
define_target "$PROJECT_TARGET_NAME" do |target|
	target.build do |environment|
		build_directory(package.path, 'source', environment)
	end
	
	target.run do |environment|
		run_executable("Applications/$PROJECT_NAME/$PROJECT_NAME", environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.provides "Application/$PROJECT_IDENTIFIER"
end

define_target "$PROJECT_TARGET_NAME-tests" do |target|
	target.build do |environment|
		build_directory(package.path, 'test', environment)
	end
	
	target.run do |environment|
		run_executable("bin/$PROJECT_TARGET_NAME-test-runner", environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.depends "Library/UnitTest"
	
	target.provides "Test/$PROJECT_IDENTIFIER"
end

define_configuration "$PROJECT_TARGET_NAME" do |configuration|
	configuration.import! "project"
end
