# regtools-cwl
cwl workflow for running regtools

# toil command
cd ./regtools-cwl/gdc_client/
cwltool --outdir /Users/zskidmor/Desktop/cwl_test workflow.cwl run.yml

### notes
Note that the run.yml file specifies the inputs for the workflow, these inputs are from the test data for regtools and can be obtained after cloning the regtools [repo](https://github.com/griffithlab/regtools)
