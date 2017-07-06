
# Project Metadata

define_project '$PROJECT_NAME' do |project|
	project.description = <<-EOF
		$PROJECT_NAME description.
	EOF
	
	project.summary = '$PROJECT_NAME is so awesome.'
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
	target.build do
		run tests: '$PROJECT_IDENTIFIER', source_files: target.package.path.glob('test/$PROJECT_IDENTIFIER/**/*.cpp')
	end
	
	target.depends 'Library/UnitTest'
	target.depends 'Library/$PROJECT_IDENTIFIER'

	target.provides 'Test/$PROJECT_IDENTIFIER'
end

define_target '$PROJECT_TARGET_NAME-executable' do |target|
	target.build do
		source_root = target.package.path + 'source'
		
		build executable: '$PROJECT_IDENTIFIER', source_files: source_root.glob('$PROJECT_IDENTIFIER.cpp')
	end
	
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends :platform
	target.depends 'Language/C++14', private: true
	
	target.depends 'Library/$PROJECT_IDENTIFIER'
	target.provides 'Executable/$PROJECT_IDENTIFIER'
end

define_target '$PROJECT_TARGET_NAME-run' do |target|
	target.build do |*argv|
		run executable: '$PROJECT_IDENTIFIER', arguments: argv
	end
	
	target.depends 'Executable/$PROJECT_IDENTIFIER'
	target.provides 'Run/$PROJECT_IDENTIFIER'
end

# Configurations

define_configuration '$PROJECT_TARGET_NAME' do |configuration|
	# Provides all the build related infrastructure:
	configuration.require 'platforms'
	
	# Provides unit testing infrastructure and generators:
	configuration.require 'unit-test'
	
	# Provides some useful C++ generators:
	configuration.require 'language-cpp-class'
end
