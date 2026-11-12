.pragma library

function parseVersion(fileName) {
    const label = String(fileName || '').replace(/\.md$/i, '');
    const match = /^v?(\d+(?:\.\d+)*)(?:-([0-9A-Za-z.]+))?$/.exec(label);
    if (!match)
        return null;
    return {
        label: label,
        parts: match[1].split('.').map(function(part) { return parseInt(part, 10); }),
        suffix: (match[2] || '').toLowerCase()
    };
}

function versionRank(suffix) {
    if (suffix === '')
        return 4;
    if (suffix.indexOf('rc') === 0)
        return 3;
    if (suffix.indexOf('beta') === 0)
        return 2;
    if (suffix.indexOf('alpha') === 0)
        return 1;
    return 0;
}

function compareVersions(a, b) {
    const length = Math.max(a.parts.length, b.parts.length);
    for (let i = 0; i < length; ++i) {
        const left = a.parts[i] || 0;
        const right = b.parts[i] || 0;
        if (left !== right)
            return left - right;
    }
    return versionRank(a.suffix) - versionRank(b.suffix);
}

function isSameVersion(a, b) {
    const length = Math.max(a.parts.length, b.parts.length);
    for (let i = 0; i < length; ++i) {
        if ((a.parts[i] || 0) !== (b.parts[i] || 0))
            return false;
    }
    return true;
}

/*! 生成按版本从新到旧排序的列表，忽略目录中不是版本号命名的文件 */
function buildVersionList(fileNames, currentVersion) {
    const current = parseVersion(currentVersion);
    const items = [];
    for (let i = 0; i < fileNames.length; ++i) {
        const version = parseVersion(fileNames[i]);
        if (version === null)
            continue;
        items.push({
                       key: version.label,
                       file: fileNames[i],
                       label: version.label,
                       version: version,
                       isCurrent: current !== null && isSameVersion(version, current)
                   });
    }
    items.sort(function(a, b) { return compareVersions(b.version, a.version); });
    return items;
}
