# Teapot configuration generated at xx.xx.xx

required_version "x.x.x"

define_target "$PROJECT_TARGET_NAME" do |target|
	target.build do |environment|
		build_directory(package.path, 'source', environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.provides "Application/$PROJECT_IDENTIFIER"
end

define_target "$PROJECT_TARGET_NAME-tests" do |target|
	target.build do |environment|
		build_directory(package.path, 'test', environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.depends "Library/UnitTest"
	
	target.provides "Test/$PROJECT_IDENTIFIER"
end

define_configuration "$PROJECT_TARGET_NAME" do |configuration|
	configuration[:source] = "xxx"
	
	configuration.import! "project"
end
