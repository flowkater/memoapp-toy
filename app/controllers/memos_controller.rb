class MemosController < ApplicationController
  before_action :authenticate_request!

  # POST /api/memos
  def create
    return render_error(400, 2, 'content는 필수') unless content_present?

    memo = current_account.memos.create!(memo_param)

    render_success 201, memo: memo.as_json
  end

  # GET /api/memos
  def index
    count = params[:count] || 6
    before_id = params[:before_id]
    memos = if before_id.present?
              current_account.memos.where('id < ?', before_id).order(id: :desc).limit(count)
            else
              current_account.memos.order(id: :desc).limit(count)
    end

    render_success :ok, memos: memos.as_json
  end

  # DELETE /api/memos/:id
  def destroy
    return render_error 400, 1, 'Invalid ID' unless match_regex_id
    return render_error 422, 3, 'No Resource' unless memo = find_memo
    return render_error 422, 4, 'Permision Failure' unless memo.account_id == current_account.id

    memo.destroy!

    render_success :ok, memo: memo.as_json
  end

  # PATCH /api/memos/:id
  def update
    return render_error 400, 1, 'Invalid ID' unless match_regex_id
    return render_error 422, 2, 'Empty Content' unless content_present?
    return render_error 422, 3, 'No Resource' unless memo = find_memo
    return render_error 422, 4, 'Permision Failure' unless memo.account_id == current_account.id

    memo.update(memo_param.merge(is_edited: true))

    render status: 201, json: { success: true, memo: memo.as_json }
  end

  private

  def content_present?
    params[:content].present?
  end

  def match_regex_id
    /\d+/.match(params[:id].to_s)
  end

  def find_memo
    Memo.find_by(id: params[:id])
  end

  def memo_param
    {
      content: params[:content]
    }
  end
end
