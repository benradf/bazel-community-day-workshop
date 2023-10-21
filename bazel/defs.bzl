def _generate_entrypoint_impl(repository_ctx):
    """
    Generate entrypoint.sh script for the docker image
    to inject build version and date.
    """
    repository_ctx.report_progress("Generating entrypoint.sh...")
    build_datetime = repository_ctx.execute(["date"]).stdout
    repository_ctx.template(
        "entrypoint.sh",
        Label("//bazel:entrypoint.sh.tpl"),
        {
            "%{DATETIME}%": build_datetime,
        },
    )

    repository_ctx.template(
        "BUILD.bazel",
        Label("//bazel:BUILD.bazel.tpl"),
        {},
    )

generate_entrypoint = repository_rule(
    implementation = _generate_entrypoint_impl,
    local = True,
)
