<img height="100" alt="hypertest_logo" src="https://user-images.githubusercontent.com/1688653/159473714-384e60ba-d830-435e-a33f-730df3c3ebc6.png">

HyperExecute is a smart test orchestration platform to run end-to-end Selenium tests at the fastest speed possible. HyperExecute lets you achieve an accelerated time to market by providing a test infrastructure that offers optimal speed, test orchestration, and detailed execution logs.

The overall experience helps teams test code and fix issues at a much faster pace. HyperExecute is configured using a YAML file. Instead of moving the Hub close to you, HyperExecute brings the test scripts close to the Hub!

* <b>HyperExecute HomePage</b>: https://www.lambdatest.com/hypertest
* <b>Lambdatest HomePage</b>: https://www.lambdatest.com
* <b>LambdaTest Support</b>: [support@lambdatest.com](mailto:support@lambdatest.com)

To know more about how HyperExecute does intelligent Test Orchestration, do check out [HyperExecute Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/)

# How to run Selenium automation tests on HyperExecute (using WbdriverIO framework)

* [Pre-requisites](#pre-requisites)
   - [Download Concierge](#download-concierge)
   - [Configure Environment Variables](#configure-environment-variables)

* [Matrix Execution with PyTest](#matrix-execution-with-pytest)
   - [Core](#core)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching)
   - [Post Steps](#post-steps)
   - [Artefacts Management](#artefacts-management)
   - [Test Execution](#test-execution)

* [Auto-Split Execution with PyTest](#auto-split-execution-with-pytest)
   - [Core](#core-1)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching-1)
   - [Post Steps](#post-steps-1)
   - [Artefacts Management](#artefacts-management-1)
   - [Test Execution](#test-execution-1)

* [Secrets Management](#secrets-management)
* [Navigation in Automation Dashboard](#navigation-in-automation-dashboard)

# Pre-requisites

Before using HyperExecute, you have to download Concierge CLI corresponding to the host OS. Along with it, you also need to export the environment variables *LT_USERNAME* and *LT_ACCESS_KEY* that are available in the [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile) page.

## Download Concierge

Concierge is a CLI for interacting and running the tests on the HyperExecute Grid. Concierge provides a host of other useful feature that accelerate test execution. In order to trigger tests using Concierge, you need to download the Concierge binary corresponding to the platform (or OS) from where the tests are triggered:

Also, it is recommended to download the binary in the project's parent directory. Shown below is the location from where you can download the Concierge binary:

* Mac: https://downloads.lambdatest.com/concierge/darwin/concierge
* Linux: https://downloads.lambdatest.com/concierge/linux/concierge
* Windows: https://downloads.lambdatest.com/concierge/windows/concierge.exe

## Configure Environment Variables

Before the tests are run, please set the environment variables LT_USERNAME & LT_ACCESS_KEY from the terminal. The account details are available on your [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile) page.

For macOS:

```bash
export LT_USERNAME=LT_USERNAME
export LT_ACCESS_KEY=LT_ACCESS_KEY
```

For Linux:

```bash
export LT_USERNAME=LT_USERNAME
export LT_ACCESS_KEY=LT_ACCESS_KEY
```

For Windows:

```bash
set LT_USERNAME=LT_USERNAME
set LT_ACCESS_KEY=LT_ACCESS_KEY
```

# Matrix Execution with PyTest

Matrix-based test execution is used for running the same tests across different test (or input) combinations. The Matrix directive in HyperExecute YAML file is a *key:value* pair where value is an array of strings.

Also, the *key:value* pairs are opaque strings for HyperExecute. For more information about matrix multiplexing, check out the [Matrix Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/#matrix-based-build-multiplexing)

### Core

In the current example, matrix YAML file (*hypertest_matrix.yaml*) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testSuite timeout, and testSuite timeout are set to 90 minutes.

The target platform is set to Windows. Please set the *[runson]* key to *[win]* if the tests have to be executed on the macOS platform.

```yaml
runson: win
```

Ruby-Capybara feature files in the 'feature' folder contain the feature Scenario run on the HyperExecute grid. In the example, the feature file *feature/ToDo.feature* run in parallel on the basis of scenario by using the features field input combinations.

```yaml
matrix:
  os: [win]
  files: ["features/todo_test1.feature", "features/todo_test2.feature"]

```

The *testSuites* object contains a list of commands (that can be presented in an array). In the current YAML file, commands for executing the tests are put in an array (with a '-' preceding each item). The bundle exec cucumber command is used to run tests in *.feature* files. The tags are mentioned as an array to the *files* key that is a part of the matrix.

```yaml
testSuites:
  - bundle exec cucumber "$files" --format html --out cucumber_results.html
```

### Pre Steps and Dependency Caching

Dependency caching is enabled in the YAML file to ensure that the package dependencies are not downloaded in subsequent runs. The first step is to set the Key used to cache directories.

```yaml
cacheKey: '{{ checksum "Gemfile.lock" }}'
```

Set the array of files & directories to be cached. In the example, all the packages will be cached in the *CacheDir* directory.

```yaml
cacheDirectories:
  - /vendor
```

Steps (or commands) that must run before the test execution are listed in the *pre* run step. In the example, the packages listed in *requirements.txt* are installed using the *bundle install --deployment* command.

```yaml
pre:
  - bundle install --deployment
```


### Artefacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artefacts and combing artefacts generated under each task.

The *uploadArtefacts* directive informs HyperExecute to upload artefacts [files, reports, etc.] generated after task completion. In the example, *path* consists of a regex for parsing the directory (i.e. *reports* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
 - name: report
   path:
     - cucumber_results.html
```

HyperExecute also facilitates the provision to download the artefacts on your local machine. To download the artefacts, click on Artefacts button corresponding to the associated TestID.

## Test Execution

The CLI option *--config* is used for providing the custom HyperExecute YAML file (i.e. *hypertest_matrix.yaml*). Run the following command on the terminal to trigger the tests in feature file Scenario on the HyperExecute grid.

```bash
./concierge --config --verbose -i hypertest_matrix.yaml
```

Visit [HyperExecute Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution:


## Auto-Split Execution with Ruby-Capybara

Auto-split execution mechanism lets you run tests at predefined concurrency and distribute the tests over the available infrastructure. Concurrency can be achieved at different levels - file, module, test suite, test, scenario, etc.

For more information about auto-split execution, check out the [Auto-Split Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/#smart-auto-test-splitting)

### Core

Auto-split YAML file (*hypertest_autosplit.yaml*) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testSuite timeout, and testSuite timeout are set to 90 minutes.

The *runson* key determines the platform (or operating system) on which the tests are executed. Here we have set the target OS as Windows.

```yaml
runson: win
```

Auto-split is set to true in the YAML file.

```yaml
 autosplit: true
```

*retryOnFailure* is set to true, instructing HyperExecute to retry failed command(s). The retry operation is carried out till the number of retries mentioned in *maxRetries* are exhausted or the command execution results in a *Pass*. In addition, the concurrency (i.e. number of parallel sessions) is set to 2.

```yaml
retryOnFailure: true
runson: win
maxRetries: 2
```

## Pre Steps and Dependency Caching

To leverage the advantage offered by *Dependency Caching* in HyperExecute, the integrity of *package-lock.json* is checked using the checksum functionality.

```yaml
cacheKey: '{{ checksum "Gemfile.lock" }}'
```

The caching advantage offered by *NPM* can be leveraged in HyperExecute, whereby the downloaded packages can be stored (or cached) in a secure server for future executions. The packages available in the cache will only be used if the checksum stage results in a Pass.



```yaml
cacheDirectories:
  - /vendor
```

The *testDiscovery* directive contains the command that gives details of the mode of execution, along with detailing the command that is used for test execution. Here, we are fetching the list of feature file scenario that would be further executed using the *value* passed in the *testRunnerCommand*

```yaml
testDiscovery:
  type: raw
  mode: dynamic
  command: snooper --featureFilePaths=features/ --frameWork=java

  testRunnerCommand: bundle exec cucumber "$test" --format html --out cucumber_results.html
```

Running the above command on the terminal will give a list of feature Scenario lines that are located in the Project folder:

Test Discovery Output:
features/todo_test1.feature:4
features/todo_test2.feature:4

The *testRunnerCommand* contains the command that is used for triggering the test. The output fetched from the *testDiscoverer* command acts as an input to the *testRunner* command.

```yaml
testRunnerCommand: bundle exec cucumber "$test" --format html --out cucumber_results.html
```

### Artefacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artefacts and combing artefacts generated under each task.

The *uploadArtefacts* directive informs HyperExecute to upload artefacts [files, reports, etc.] generated after task completion.  In the example, *path* consists of a regex for parsing the directory (i.e. *reports* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
 - name: report
   path:
     - cucumber_results.html

```
HyperExecute also facilitates the provision to download the artefacts on your local machine. To download the artefacts, click on *Artefacts* button corresponding to the associated TestID.

### Test Execution

The CLI option *--config* is used for providing the custom HyperExecute YAML file (i.e. *hypertest_matrix.yaml*). Run the following command on the terminal to trigger the tests in Python files on the HyperExecute grid. The *--download-artifacts* option is used to inform HyperExecute to download the artefacts for the job.

```bash
./concierge --config --verbose -i .hypertest_matrix.yaml
```

Visit [HyperExecute Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution



## Secrets Management

In case you want to use any secret keys in the YAML file, the same can be set by clicking on the *Secrets* button the dashboard.

steps:
1. Open HyperExecute Dashboard  
2. Click on Secrets
3. Add Secrets with Name as AccessKey
All you need to do is create an environment variable that uses the secret key:

```yaml
env:
  AccessKey: ${{.secrets.AccessKey}}
```

## Report Generation

In case you want to generate hypertest report you can use below yaml directives and you can download report from button on dashboard and also you will find report under your frameWork also.


All you need to do is create an environment variable that uses the secret key:

```yaml
env:
  AccessKey: ${{.secrets.AccessKey}}
```

## Navigation in Automation Dashboard

HyperExecute lets you navigate from/to *Test Logs* in Automation Dashboard from/to *HyperExecute Logs*. You also get relevant get relevant Selenium test details like video, network log, commands, Exceptions & more in the Dashboard. Effortlessly navigate from the automation dashboard to HyperExecute logs (and vice-versa) to get more details of the test execution.


## We are here to help you :)
* LambdaTest Support: [support@lambdatest.com](mailto:support@lambdatest.com)
* HyperExecute HomePage: https://www.lambdatest.com/support/docs/getting-started-with-hypertest/
* Lambdatest HomePage: https://www.lambdatest.com
