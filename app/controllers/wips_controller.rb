class WipsController < ApplicationController
  before_action :require_logged_in
  before_action :set_wip, only: [:show, :edit, :update, :destroy]
  before_action :get_session, only: [:show, :edit, :update]

  def get_session
    @session = Session.find(@wip.session_id)

  end

  # GET /wips
  # GET /wips.json
  def index
    @wips = Wip.all
  end

  # GET /wips/1
  # GET /wips/1.json
  def show
  end

  # GET /wips/new
  def new
    @wip = Wip.new
  end

  # GET /wips/1/edit
  def edit
  end

  # POST /wips
  # POST /wips.json
  def create
    @wip = Wip.new(wip_params)

    respond_to do |format|
      if @wip.save
        format.html { redirect_to @session, notice: 'Wip was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @wip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wips/1
  # PATCH/PUT /wips/1.json
  def update
    wip_item = params[:content]
    respond_to do |format|
      if @wip.update(wip_item: wip_item)
        # format.html { redirect_to @session, notice: 'Wip was successfully updated.' }
        # format.json { render :show, status: :ok, location: @session }
        # format.js {render :nothing => true, notice: 'Wip was successfully updated.' }
      else
        # format.html { render :edit }
        # format.json { render json: @wip.errors, status: :unprocessable_entity }
      end
      # redirect_to session.delete(:return_to)
    end
  end

  # DELETE /wips/1
  # DELETE /wips/1.json
  def destroy
    @wip.destroy
    respond_to do |format|
      format.html { redirect_to wips_url, notice: 'Wip was successfully destroyed.' }
      format.json { head :no_content }
      Wip.reset_pk_sequence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wip
      @wip = Wip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wip_params
      params.require(:wip).permit(:session_id, :user_id, :wip_item)
    end
end
