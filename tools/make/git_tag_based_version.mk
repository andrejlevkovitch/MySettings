# provide `version` variable based on git tag version (major and minor) and git commits (patches)

git_tag_version_pattern=v[0-9]*\.[0-9]*


git_version_tag=$(shell git describe --tags --match "${git_tag_version_pattern}" --abbrev=0 2> /dev/null)

git_local_head_hash=$(shell git rev-parse HEAD)
git_remote_head_hash=$(shell git rev-parse remotes/origin/HEAD)

git_is_on_master=$(shell ! git merge-base --is-ancestor ${git_local_head_hash} ${git_remote_head_hash}; echo $$?)
git_branch=$(shell git name-rev --name-only --exclude=remotes/* --exclude=tags/* ${git_local_head_hash} | sed -e "s/~[0-9]\\+$$//g" | sed s/_/-/g | sed s/\\//-/g)

git_master_base_hash=$(shell git merge-base --all ${git_local_head_hash} ${git_remote_head_hash} | head -1)


ifeq (${git_version_tag},)
	git_version_tag=v0.0
	git_version_tag_hash=$(shell git rev-list --max-parents=0 HEAD)
else
	git_version_tag_hash=$(shell git rev-list -n 1 ${git_version_tag})
endif


mm_version=$(git_version_tag)
patch=$(shell git rev-list ${git_version_tag_hash}..${git_master_base_hash} --count)
ifeq (${patch},)
	patch=0
endif


version=$(mm_version).$(patch)
version_raw=$(shell echo ${version} | cut -c 2-)

ifeq (${git_is_on_master},0)
	local_patch_diff=$(shell git rev-list ${git_master_base_hash}..${git_local_base_tag_version} --count)
	version:=${version}-${local_patch_diff}-${git_branch}
endif
