import groovy.json.JsonBuilder
import groovy.json.JsonSlurper

String envarsFileLocation = '/Users/swinchester/BP/jboss-amq-jdbc-dockerfile/.s2i/environment'
String parentTemplateLocation = '/Users/swinchester/BP/jboss-amq-jdbc-dockerfile/template.json'


def varMap = [:]

String envVars = new File(envarsFileLocation).eachLine {
    String [] kvp = it.split('=')
    varMap.put(kvp[0],kvp[1])
}

println varMap

//append vars into json...
def js= new JsonSlurper().parseText(new File('/Users/swinchester/BP/jboss-amq-jdbc-dockerfile/template.json').text)

def jb = new JsonBuilder(js)

def deployConfig = jb.content.objects.find { it.kind == 'DeploymentConfig' }

varMap.each { k, v ->

    def paramMap = [description:'',
                    name:k,
                    required:true,
                    value:v]

    jb.content.parameters.add(paramMap)

    def envVarMap = [name: k.toString(), value: "\${" + k.toString() + "}"]
    deployConfig.spec.template.spec.containers[0].env << envVarMap

}

println(jb.toPrettyString())