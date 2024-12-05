require('mini.surround').setup({
    custom_surroundings = {
        ['('] = {
            input = {'%b()', '^.%s*().-()%s*.$'},
            output = {left = '(', right = ')'}
        },
        ['['] = {
            input = {'%b[]', '^.%s*().-()%s*.$'},
            output = {left = '[', right = ']'}
        },
        ['{'] = {
            input = {'%b{}', '^.%s*().-()%s*.$'},
            output = {left = '{', right = '}'}
        },
        ['<'] = {
            input = {'%b<>', '^.%s*().-()%s*.$'},
            output = {left = '<', right = '>'}
        }
    }
})
