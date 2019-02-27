import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.*


def jobName = "DemoApp_Ci_Cd"
def desc = "DemoApp Workshop CI CD Flow"
def pipelinScript = "./scripts/DemoApp_Ci_Cd_Pipeline"

def nexusURL = "http://localhost:8081"
def tomcatPATH = "/usr/local/tomcat"


pipelineJob(jobName) {  
    description(desc)
    concurrentBuild(false)
    logRotator(10,10)
	disabled(false)

	environmentVariables(NEXUS_URL: nexusURL, TOMCAT_PATH: tomcatPATH)
    
    triggers {
            scm('* * * * *')
    }

    definition {
        cps {
            script(readFileFromWorkspace(pipelinScript).stripIndent())
       	    sandbox()
        }
    }
}
