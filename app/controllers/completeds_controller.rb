class CompletedsController < ApplicationController
  before_action :require_logged_in
  before_action :set_completed, only: [:show, :edit, :update, :destroy]
  before_action :get_session, only: [:show, :edit, :update]


  # GET /completeds
  # GET /completeds.json

  def get_session
    @session = Session.find(@completed.session_id)
  end

  def index
    @completeds = Completed.all
  end

  # GET /completeds/1
  # GET /completeds/1.json
  def show
  end

  # GET /completeds/new
  def new
    @completed = Completed.new
  end

  # GET /completeds/1/edit
  def edit
  end

  # POST /completeds
  # POST /completeds.json
  def create
    @completed = Completed.new(completed_params)
    respond_to do |format|
      if @completed.save
        format.html { redirect_to @completed, notice: 'Completed was successfully created.' }
        format.json { render :show, status: :created, location: @completed }
      else
        format.html { render :new }
        format.json { render json: @completed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /completeds/1
  # PATCH/PUT /completeds/1.json
  def update
    completed_item = params[:content]
    respond_to do |format|
      if @completed.update(completed: completed_item)
        # format.html { redirect_to @session, notice: 'Completed was successfully updated.' }
        # format.json { render :show, status: :ok, location: @session }
        # format.js {render :nothing => true, notice: 'Wip was successfully updated.' }
      else
        # format.html { render :edit }
        # format.json { render json: @completed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /completeds/1
  # DELETE /completeds/1.json
  def destroy
    @completed.destroy
    respond_to do |format|
      format.html { redirect_to completeds_url, notice: 'Completed was successfully destroyed.' }
      format.json { head :no_content }
      Completed.reset_pk_sequence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_completed
      @completed = Completed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def completed_params
      params.require(:completed).permit(:session_id, :user_id, :completed)
    end
end
