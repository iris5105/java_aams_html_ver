pipeline {
    agent any

    // 2분마다 Git 저장소의 변경사항(커밋/푸시)을 자동 감지하여 빌드 실행
    triggers {
        pollSCM('H/2 * * * *')
    }

    environment {
        JAVA_HOME = '/home/aams/aams_web/jdk/jdk-21.0.12'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
        DEPLOY_DIR = '/home/aams/aams_web'
        JAR_NAME = 'aams-0.0.1-SNAPSHOT.jar'
        PORT = '4001'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '>>> [1/3] Git 소스코드 최신 버전 체크아웃...'
                checkout scm
            }
        }

        stage('Build (Java 21)') {
            steps {
                echo '>>> [2/3] Maven 패키징 빌드 시작...'
                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                '''
            }
        }

        stage('Deploy & 24h Background Run') {
            steps {
                echo '>>> [3/3] 무중단 백그라운드 배포 및 실행...'
                sh '''
                    # 1. 배포 폴더 준비
                    mkdir -p ${DEPLOY_DIR}

                    # 2. 기존 실행 중인 웹서버 확인 및 안전 종료
                    PID=$(pgrep -f "${JAR_NAME}" || true)
                    if [ -n "$PID" ]; then
                        echo ">>> 기존 실행 중인 프로세스 종료 (PID: $PID)..."
                        kill -15 $PID || true
                        sleep 4
                    fi

                    # 3. 신규 빌드된 JAR 배포 폴더로 복사
                    cp target/${JAR_NAME} ${DEPLOY_DIR}/${JAR_NAME}

                    # 4. 젠킨스가 빌드 종료 후 프로세스를 종료시키지 않도록 설정하고 24시간 백그라운드 실행
                    echo ">>> AAMS 서버 24시간 백그라운드 구동 시작..."
                    BUILD_ID=dontKillMe JENKINS_NODE_COOKIE=dontKillMe nohup ${JAVA_HOME}/bin/java -jar ${DEPLOY_DIR}/${JAR_NAME} --server.port=${PORT} > ${DEPLOY_DIR}/app.log 2>&1 &

                    sleep 5

                    # 5. 실행 확인
                    NEW_PID=$(pgrep -f "${JAR_NAME}" || true)
                    if [ -n "$NEW_PID" ]; then
                        echo ">>> 배포 성공! 신규 프로세스 PID: ${NEW_PID}"
                        echo ">>> 포트 4001 정상 구동 완료. 로그: tail -f ${DEPLOY_DIR}/app.log"
                    else
                        echo ">>> 경고: 프로세스 시작 확인 필요. 로그를 확인하세요:"
                        tail -n 20 ${DEPLOY_DIR}/app.log
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "========================================="
            echo "🎉 AAMS 웹서버 배포가 성공적으로 완료되었습니다!"
            echo "접속 주소: http://172.20.5.100:4001/login"
            echo "========================================="
        }
        failure {
            echo "❌ 배포 중 오류가 발생했습니다. 로그를 확인해 주세요."
        }
    }
}