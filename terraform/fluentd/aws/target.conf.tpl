<label @target>
	<filter **>
		@type record_transformer
		enable_ruby true
		<record>
			group_name /convox/$${record["kubernetes"]["namespace_labels"]["rack"]}/$${record["kubernetes"]["namespace_labels"]["app"]}
			stream_name service/$${record["kubernetes"]["labels"]["service"]}/$${record["kubernetes"]["pod_name"]}
		</record>
	</filter>

	<match **>
		@type cloudwatch_logs
		region ${region}
		auto_create_stream true
		retention_in_days 7
		log_group_name_key group_name
		log_stream_name_key stream_name
		message_keys log
		remove_log_group_name_key true
		remove_log_stream_name_key true
		<buffer>
			flush_interval 1
			chunk_limit_size 2m
			queued_chunks_limit_size 32
			retry_forever true
		</buffer>
	</match>
</label>