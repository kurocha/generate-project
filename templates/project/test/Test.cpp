
#include <UnitTest/UnitTest.h>

namespace $PROJECT_IDENTIFIER
{
	UnitTest::Suite ProjectTestSuite {
		"$PROJECT_IDENTIFIER",
		
		{"Default Tests",
			[](UnitTest::Examiner & examiner) {
				examiner << "Testing basic logic" << std::endl;
				examiner.check(true == true);
			}
		},
	};
}
