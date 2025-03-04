defmodule AshPostgres.TestRepo.Migrations.MigrateResources4 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    drop constraint(:users, "users_org_id_fkey")

    alter table(:users) do
      modify :org_id,
             references(:multitenant_orgs,
               column: :id,
               name: "users_org_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:posts) do
      modify :decimal, :decimal, default: "0"
      add :point, {:array, :float}
    end

    drop constraint(:post_links, "post_links_destination_post_id_fkey")

    drop constraint(:post_links, "post_links_source_post_id_fkey")

    alter table(:post_links) do
      modify :source_post_id,
             references(:posts,
               column: :id,
               prefix: "public",
               name: "post_links_source_post_id_fkey",
               type: :uuid
             )
    end

    alter table(:post_links) do
      modify :destination_post_id,
             references(:posts,
               column: :id,
               prefix: "public",
               name: "post_links_destination_post_id_fkey",
               type: :uuid
             )
    end

    drop constraint(:comments, "comments_author_id_fkey")

    drop constraint(:comments, "special_name_fkey")

    alter table(:comments) do
      modify :post_id,
             references(:posts,
               column: :id,
               prefix: "public",
               name: "special_name_fkey",
               type: :uuid,
               on_delete: :delete_all,
               on_update: :update_all
             )
    end

    alter table(:comments) do
      modify :author_id,
             references(:authors,
               column: :id,
               prefix: "public",
               name: "comments_author_id_fkey",
               type: :uuid
             )
    end
  end

  def down do
    drop constraint(:comments, "comments_author_id_fkey")

    alter table(:comments) do
      modify :author_id,
             references(:authors, column: :id, name: "comments_author_id_fkey", type: :uuid)
    end

    drop constraint(:comments, "special_name_fkey")

    alter table(:comments) do
      modify :post_id,
             references(:posts,
               column: :id,
               name: "special_name_fkey",
               type: :uuid,
               on_delete: :delete_all,
               on_update: :update_all
             )
    end

    drop constraint(:post_links, "post_links_destination_post_id_fkey")

    alter table(:post_links) do
      modify :destination_post_id,
             references(:posts,
               column: :id,
               name: "post_links_destination_post_id_fkey",
               type: :uuid
             )
    end

    drop constraint(:post_links, "post_links_source_post_id_fkey")

    alter table(:post_links) do
      modify :source_post_id,
             references(:posts, column: :id, name: "post_links_source_post_id_fkey", type: :uuid)
    end

    alter table(:posts) do
      remove :point
      modify :decimal, :decimal, default: 0
    end

    drop constraint(:users, "users_org_id_fkey")

    alter table(:users) do
      modify :org_id,
             references(:multitenant_orgs, column: :id, name: "users_org_id_fkey", type: :uuid)
    end
  end
end