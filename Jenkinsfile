pipeline {
    // 젠킨스의 구동 환경(노드)을 지정합니다. any는 사용 가능한 아무 에이전트나 할당한다는 의미입니다.
    agent any

    stages {
        stage('Checkout') {
            steps {
                // UI에서 설정한 레포지토리 주소, 브랜치, Sparse Checkout 설정을 실행하여 코드를 다운로드합니다.
                checkout scm
            }
        }
        
        stage('Verify Files') {
            steps {
                // 리눅스 환경에서 현재 다운로드된 파일 목록을 로그에 출력하여 의도한 폴더만 있는지 확인합니다.
                sh 'ls -al'
            }
        }
    }
}