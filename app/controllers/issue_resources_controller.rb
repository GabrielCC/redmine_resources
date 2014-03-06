class IssueResourcesController < BaseController
  
  # GET /issue_resources
  # GET /issue_resources.json
  def index
    @issue_resources = IssueResource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issue_resources }
    end
  end

  # GET /issue_resources/1
  # GET /issue_resources/1.json
  def show
    @issue_resource = IssueResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue_resource }
    end
  end

  # GET /issue_resources/new
  # GET /issue_resources/new.json
  def new
    @issue_resource = IssueResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue_resource }
    end
  end

  # GET /issue_resources/1/edit
  def edit
    @issue_resource = IssueResource.find(params[:id])
  end

  # POST /issue_resources
  # POST /issue_resources.json
  def create
    @issue_resource = IssueResource.from_params(params)

    
    if @issue_resource.save
      partial = "issue_resources/saved"
    else
      partial = 'issue_resources/failed'
    end
    render :partial => partial, :layout => false, :content_type => 'application/javascript'
  end

  # PUT /issue_resources/1
  # PUT /issue_resources/1.json
  def update
    @issue_resource = IssueResource.find(params[:id])

    respond_to do |format|
      if @issue_resource.update_attributes(params[:issue_resource])
        format.html { redirect_to @issue_resource, notice: 'IssueResource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_resources/1
  # DELETE /issue_resources/1.json
  def destroy
    @issue_resource = IssueResource.find(params[:id])
    @issue_resource.destroy

    respond_to do |format|
      format.html { redirect_to issue_resources_url }
      format.json { head :no_content }
    end
  end
end
