

function CanCreateProject()
    local job = GetJob()
    return job.grade >= Config.creatorGrade
end

function CanRemoveProject()
    local job = GetJob()
    return job.grade >= Config.creatorGrade
end

function CanUnpublishProject()
    local job = GetJob()
    return job.grade >= Config.publisherGrade
end

function CanPublishProject()
    local job = GetJob()
    return job.grade >= Config.publisherGrade
end

function CanOpenMenu()
    local job = GetJob()
    return job.name == Config.jobName
end
