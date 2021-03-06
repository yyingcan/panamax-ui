class DeploymentsController < ApplicationController
  respond_to :html
  respond_to :json, only: [:destroy, :show]

  def new
    @template = Template.find(params[:template_id])
    @deployment_target = DeploymentTarget.find(target_id)
    @deployment_form = DeploymentForm.new(
      template: @template,
      deployment_target_id: target_id
    )
  end

  def create
    @deployment_form = DeploymentForm.new(params[:deployment_form])
    if @deployment_form.save
      flash[:success] = I18n.t('deployments.create.success')
    else
      flash[:error] = I18n.t('deployments.create.error')
    end
    respond_with @deployment_form, location: deployment_target_deployments_path(target_id)
  end

  def index
    @deployment_target = DeploymentTarget.find(target_id)
    @deployments = Deployment.all(params: { deployment_target_id: target_id })
  end

  def destroy
    deployment = Deployment.find(params[:id], params: { deployment_target_id: target_id })
    respond_with(deployment.destroy, location: deployment_target_deployments_path(target_id))
  end

  def show
    respond_with(Deployment.find(params[:id], params: { deployment_target_id: target_id }))
  end

  private

  def target_id
    params[:deployment_target_id]
  end
end
