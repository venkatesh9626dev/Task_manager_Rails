json.status_message@status_message
json.message @message
json.data @comments do |comment|

  json.comment_id comment.id
    json.comment_body comment.body
    json.comment_created_at comment.created_at
    json.comment_updated_at comment.updated_at
    json.comment_user_id comment.user.id
    json.comment_user_name comment.user.username
  
end