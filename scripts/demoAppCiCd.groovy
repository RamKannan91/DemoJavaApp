import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Job
import javaposse.jobdsl.dsl.*


def jobName = "DemoApp_Ci_Cd"
def desc = "DemoApp Workshop CI CD Flow"
def pipelinScript = "./scripts/DemoApp_Ci_Cd_Pipeline"

def nexusURL = "http://100.122.214.160:8081/"
def tomcatURL = "http://100.122.214.160:8080/"


pipelineJob(jobName) {  
    description(desc)
    concurrentBuild(false)
    logRotator(10,10)
	disabled(false)

	environmentVariables(COMMAND_TO_USE: "create-user")

    definition {
        cps {
            script(readFileFromWorkspace(pipelinScript).stripIndent())
       	    sandbox()
        }
    }
}
