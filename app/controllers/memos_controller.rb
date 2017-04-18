class MemosController < ApplicationController
  before_action :authenticate_request!

  # POST /api/memos
  def create
    return render_error(400, 2, 'content는 필수') unless params[:content].present?

    memo = current_account.memos.create!(memo_param)

    render_success 201, { memo: memo.as_json }
  end

  # GET /api/memos
  def index
    memos = current_account.memos.all

    render_success :ok, { memos: memos.as_json }
  end

  # DELETE /api/memos/:id
  def destroy
    return render_error 400, 1, 'Invalid ID' unless /\d+/.match(params[:id].to_s)
    return render_error 404, 3, 'No Resource' unless memo = Memo.find_by(id: params[:id])
    return render_error 403, 4, 'Permision Failure' unless memo.account_id == current_account.id

    memo.destroy!

    render_success :ok, { memo: memo.as_json }
  end

  # PATCH /api/memos/:id
  def update
    return render_error 400, 1, 'Invalid ID' unless /\d+/.match(params[:id].to_s)
    return render_error 403, 2, 'Empty Contents' unless params[:content].present?
    return render_error 404, 3, 'No Resource' unless memo = Memo.find_by(id: params[:id])
    return render_error 403, 4, 'Permision Failure' unless memo.account_id == current_account.id

    memo.update(memo_param.merge(is_edited: true))

    render status: 201, json: { success: true, memo: memo.as_json }
  end

  private
  def memo_param
    {
      content: params[:content]
    }
  end
end
