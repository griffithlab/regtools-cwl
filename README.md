# regtools-cwl
cwl workflow for running regtools

# toil command
cwltool --outdir /Users/zskidmor/Desktop/ workflow.cwl regtools_run.yml

### notes
Note that the regtools_run.yml file specifies the inputs for the workflow, these inputs are from the test data for regtools and can be obtained after cloning the regtools [repo](https://github.com/griffithlab/regtools)
