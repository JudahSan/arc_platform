module.exports = {
    ci: {
        collect: {
            url: ['http://localhost:3000/'],
            startServerCommand: 'rails server -e development',
        },
        assert: {
            assertions: {
                'categories:performance': ['warn', { minScore: 0.9 }],
                'categories:accessibility': ['warn', { minScore: 0.9 }],
            }
        },
        upload: {
            target: 'temporary-public-storage',
        },
    },
};
