'''
Inserts text into an assembly file with a region marked for auto-generated
code. The region begins and ends with a marker with a semicolon (;) and a
line of hashtags (#) as defined below. Throws an exception if this region
is not found. Text before and after this region is unaffected, but any
existing text inside this region will be replaced with the inserted text.

; ##############################################################################
; ###          AUTOMATICALLY GENERATED CODE, DO NOT MODIFY MANUALLY          ###
; ##############################################################################

<insert_text> gets inserted here.

; ##############################################################################

'''

INSERT_MARKER = '; '.ljust(80, '#')
INSERT_MSG = 'AUTOMATICALLY GENERATED CODE, DO NOT MODIFY MANUALLY'

def insert_asm(insert_path, insert_text):
    with open(insert_path, 'r') as f:
        full_text = f.read()

    insert_start = full_text.find(INSERT_MARKER)
    insert_end = full_text.rfind(INSERT_MARKER) + len(INSERT_MARKER)

    if insert_start == -1:
        raise Exception('Unable to locate automatically generated code ' \
            'region in include file:', insert_path)

    insert_header = INSERT_MARKER + '\n; ###' + INSERT_MSG.center(72)
    insert_header += '###\n' + INSERT_MARKER + '\n\n'

    # append markers to the text to be inserted
    insert_text = insert_header + insert_text + '\n' + INSERT_MARKER

    full_text = full_text[:insert_start] + insert_text + full_text[insert_end:]

    with open(insert_path, 'w') as f:
        f.write(full_text)
