class SwellMediaMigration < ActiveRecord::Migration

	def change

		create_table :categories, force: true do |t|
			t.references 		:site
			t.references 		:parent
			t.string			:name
			t.string 			:type
			t.integer 			:lft
			t.integer 			:rgt
			t.text				:description
			t.string			:status,			default: :published
			t.string			:availability,		default: :public
			t.integer 			:seq
			t.string 			:slug
			t.timestamps
		end

		add_index :categories, :site_id
		add_index :categories, :parent_id
		add_index :categories, :type
		add_index :categories, :lft
		add_index :categories, :rgt
		add_index :categories, [ :slug, :site_id], 			unique: true


		create_table :content_subscriptions, force: true do |t|
			t.references 		:site
			t.references		:user
			t.references		:parent_object,		polymorphic: true
			t.string			:format,			default: :notification
			t.string			:frequency,			default: :realtime
			t.string			:status,			default: :active
			t.timestamps
		end

		add_index :content_subscriptions, :site_id
		add_index :content_subscriptions, :user_id
		add_index :content_subscriptions, [ :parent_object_id, :parent_object_type, :site_id ], name: 'index_content_subs_on_parent'


		create_table :filters, :force => true do |t|
			t.references 		:site
			t.references		:user
			t.string			:type
			t.string			:filter_value
			t.string 			:match_type,		default: :exact
			t.string			:status_to_apply,	default: :spam
			t.string			:status,			default: :active
			t.timestamps
		end

		add_index :filters, :site_id
		add_index :filters, :user_id
		add_index :filters, [ :type, :site_id ]
		add_index :filters, :filter_value
		

		create_table :media, :force => true do |t|
			t.references 		:site
			t.references  		:user
			t.references  		:parent
			t.references  		:category
			t.string   			:type
			t.integer			:lft
			t.integer			:rgt
			t.string 			:title
			t.string			:subtitle
			t.string			:title_tag
			t.string 			:avatar
			t.text				:description
			t.text				:content
			t.string			:status,					default: :published
			t.string			:availability,				default: :public
			t.datetime			:publication_date
			t.datetime			:publish_at
			t.datetime			:modified_at
			t.integer			:seq
			t.string			:slug
			t.boolean 			:is_explicit,				default: false
			t.boolean			:is_commentable,			default: true
			t.boolean			:is_featured,				default: false
			t.boolean			:is_sticky,					default: false
			t.boolean			:is_shareable
			t.boolean			:is_title_visible
			t.boolean			:email_author_on_comment,	default: true
			t.string			:redirect_path
			t.integer			:cached_view_count,			default: 0
			t.timestamps
		end

		add_index :media, :site_id
		add_index :media, :user_id
		add_index :media, :category_id
		add_index :media, [ :type, :site_id ]
		add_index :media, [ :slug, :site_id ], 	unique: true
		

		create_table :taggings, :force => true do |t|
			t.references		:tag
			t.references		:taggable, 	polymorphic: true
			t.references		:tagger, 	polymorphic: true
			t.string			:context
			t.timestamps
		end

		add_index :taggings, :tag_id
		add_index :taggings, [ :taggable_id, :taggable_type, :context ]


		create_table :tags, :force => true do |t|
			t.references 		:site
			t.string			:name
			t.timestamps
		end

		add_index :tags, [ :site_id, :name ], 	unique: true


		create_table :user_content, :force => true do |t|
			t.references 		:site
			t.references		:user
			t.references		:parent_object, 		polymorphic: true
			t.references		:parent
			t.integer			:lft
			t.integer			:rgt
			t.string			:type
			t.string			:title
			t.text				:content
			t.string			:ip
			t.string			:website_url
			t.string 			:slug
			t.boolean			:is_commentable,		default: true
			t.boolean			:is_sticky,				default: false
			t.string			:status,				default: :published
			t.datetime			:modified_at
			t.integer			:cached_view_count,		default: 0
			t.integer			:cached_vote_count,		default: 0
			t.integer			:cached_vote_score,		default: 0
			t.integer			:cached_upvote_count,	default: 0
			t.integer			:cached_downvote_count,	default: 0
			t.timestamps
		end

		add_index :user_content, :site_id
		add_index :user_content, :cached_downvote_count
		add_index :user_content, :cached_upvote_count
		add_index :user_content, :cached_vote_count
		add_index :user_content, :cached_vote_score
		add_index :user_content, [ :lft, :rgt ]
		add_index :user_content, :parent_id
		add_index :user_content, [ :parent_object_id, :parent_object_type, :site_id ], name: 'index_user_content_on_parent'
		add_index :user_content, [ :parent_object_type, :site_id ]
		add_index :user_content, [ :slug, :site_id ]
		add_index :user_content, [ :type, :status, :site_id ], name: 'index_user_content_on_type_status'
		add_index :user_content, :user_id


		create_table :versions, :force => true do |t|
			t.references	:item,		polymorphic: true
			t.string		:event, 	null: false
			t.string		:whodunnit
			t.text			:object
			t.text			:object_changes
			t.datetime		:created_at
		end

		add_index :versions, [ :item_type, :item_id ]
		

	end
end
