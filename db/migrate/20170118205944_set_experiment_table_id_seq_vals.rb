class SetExperimentTableIdSeqVals < ActiveRecord::Migration
  def up
    this_hostid = Machine.new.hostid

    execute %{
      SELECT setval('experiments_id_seq', GREATEST(1, CAST(1e9 * #{this_hostid}::int AS bigint)), FALSE);
      SELECT setval('experiments_sites_id_seq', GREATEST(1, CAST(1e9 * #{this_hostid}::int AS bigint)), FALSE);
      SELECT setval('experiments_treatments_id_seq', GREATEST(1, CAST(1e9 * #{this_hostid}::int AS bigint)), FALSE);
      ALTER TABLE experiments_sites ADD CONSTRAINT unique_experiment_site_pair UNIQUE (experiment_id, site_id);
      ALTER TABLE experiments_treatments ADD CONSTRAINT unique_experiment_treatment_pair UNIQUE (experiment_id, treatment_id);
    }
  end

  def down

    execute %{
      ALTER TABLE experiments_sites DROP CONSTRAINT unique_experiment_site_pair;
      ALTER TABLE experiments_treatments DROP CONSTRAINT unique_experiment_treatment_pair;
    }
    
  end
end
