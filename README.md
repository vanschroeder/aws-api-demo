# aws-api-demo
Demo AWS Application featuring REST API with Lambda Triggers and Progressive Web UI hosted on S3

#### Development & Usage Requirements
The following applications and frameworks must be installed on your local system for development

* [AWS-CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [Docker](https://www.docker.com/get-started)
* [GIT](https://git-scm.com/downloads)
* [NodeJS + NPM](https://nodejs.org/en/)
* [Terraform](https://www.terraform.io/guides/index.html)

#### NPM Script Commands
The following commands are available via npm to automate common development tasks

|  Name      | Description | Notes |
| ----------- | ---------------- | ---------------- |
| build-web | builds Vue Web UI for deployment | |
| deploy | Compresses Lambda Functions and applies Terraform configs against AWS service configuration  | performs `zip-intake`, `zip-validate` & `terraform apply` |
| dock | Executes `lambda` function in Docker VM for local development 
| plan | Performs Terraform `plan` against .tf config files |
| serve-web | starts `vue-cli` development server | |
| test | Executes Lambda handlers in Docker VMs for local testing  |
| reset | destroys all AWS resource deployments | |

### Quick Start


This Quick Start assumes all `Development Requirements` listed above are met...

*Step 1:* Clone the repo locally
```
$ git clone https://github.com/vanschroeder/aws-api-demo
```

*Step 2:* Enter repo working directory 
```
$ cd aws-api-demo
```

*Step 3:* Run setup command 
```
$ npm run setup
```

*Step 4:* Deploy AWS resources 

```
$ npm run deploy
```

#### Next Steps

##### Integrate the UI with the API
You can do this by pasting the `get-values endpoint` from the console output as the **\_\_API_URL\_\_** in `web/src/App.vue`

##### Deploy the Web UI
Copy and paste the `sync command` from the console output into the terminal and run it
you can then use the UI by opening the url listed as `webiste-url` 
   

##### Clean Up 
To remove the Service Resources & Web UI created by this Module on AWS

```
$ npm run reset
```

