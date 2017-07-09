
# Build Targets

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
	target.build do |*arguments|
		run executable: '$PROJECT_IDENTIFIER', arguments: arguments
	end
	
	target.depends 'Executable/$PROJECT_IDENTIFIER'
	target.provides 'Run/$PROJECT_IDENTIFIER'
end

# Configurations
