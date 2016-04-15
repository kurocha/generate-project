
# Project Metadata

define_project '$PROJECT_NAME' do |project|
	project.description = <<-EOF
		$PROJECT_NAME description.
	EOF
	
	project.summary = '$PROJECT_NAME short description.'
	project.license = 'MIT License'
	
	# project.add_author 'Samuel Williams', email: 'samuel@oriontransfer.org', website: 'http://www.codeotaku.com'
	# project.website = 'http://teapot.nz/projects/$PROJECT_TARGET_NAME'
	
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
	target.depends 'Language/C++11'

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
		
		build executable: '$PROJECT_IDENTIFIER', source_files: source_root.glob('main.cpp')
	end
	
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends :platform
	target.depends 'Language/C++11'
	
	target.depends 'Library/$PROJECT_IDENTIFIER'
	target.provides 'Executable/$PROJECT_IDENTIFIER'
end

# teapot brew Run/$PROJECT_IDENTIFIER -- $ARGV
define_target '$PROJECT_TARGET_NAME-run' do |target|
	target.build do
		run executable: '$PROJECT_IDENTIFIER', arguments: ARGV
	end
	
	target.depends 'Executable/$PROJECT_IDENTIFIER'
	target.provides 'Run/$PROJECT_IDENTIFIER'
end

# Configurations

define_configuration '$PROJECT_TARGET_NAME' do |configuration|
	# Provides all the build related infrastructure:
	configuration.require 'platforms'
end
