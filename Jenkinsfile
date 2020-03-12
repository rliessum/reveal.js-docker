#!groovy
@Library('github.com/cloudogu/ces-build-lib@1.35.1')
import com.cloudogu.ces.cesbuildlib.*

node('docker') {

    properties([
            // Keep only the last 10 build to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds(),
    ])

    Docker docker = new Docker(this)
    Git git = new Git(this)

    catchError {

        stage('Checkout') {
            checkout scm
            git.clean('')
        }

        def devImage
        def prodImage
        String imageName = "cloudogu/reveal.js:${createVersion(git)}"

        stage('Build Images') {
            devImage = docker.build "${imageName}-dev", '--build-arg ENV=dev .'
            prodImage = docker.build imageName, '.'
        }

        stage('Build Images') {
            // TODO smoke test for both images
        }

        stage('Deploy Images') {
            docker.withRegistry('', 'hub.docker.com-cesmarvin') {
                if (git.isTag()) {
                    devImage.push()
                    prodImage.push()
                }
                
                if (env.BRANCH_NAME == "master") {
                    devImage.push('dev')
                    prodImage.push('latest')
                }
            }
        }
    }

    mailIfStatusChanged(git.commitAuthorEmail)
}

String createVersion(git) {
    String versionName
    if (git.isTag()) {
        versionName = git.tag
        currentBuild.description = versionName
    } else {
        // E.g. "201708140933-1674930"
        versionName = "${new Date().format('yyyyMMddHHmm')}-${git.commitHashShort}"
    }
    echo "Building version ${versionName} on branch ${env.BRANCH_NAME}"

    return versionName
}