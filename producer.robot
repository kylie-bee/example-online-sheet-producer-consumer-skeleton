*** Settings ***
Documentation       Create work items based on a mocked sheet. The mocked library should
...                 be replaced with a proper implementation against an online sheet provider, such as
...                 Google Sheets or Coda.

Library             Collections
Library             RPA.Robocorp.WorkItems
Library             MockSheetProvider.py
Resource            SheetKeywords.resource


*** Variables ***
${SHEET_ID}=    1


*** Tasks ***
Create work items from sheet
    [Documentation]    Read orders from the sheet and create a work item for each order. Update
    ...    The sheet with status.
    ${table}=    Get Sheet As Table    ${SHEET_ID}
    FOR    ${row}    IN    @{table}
        # If you must only use some columns, you can choose the columns you want to keep like so:
        # Keep In Dictionary    ${row}    Status    Order ID    Owner
        # But we recommend simply passing the whole row to the consumer as a work item.
        ${output}=    Create Output Work Item    ${row}    save=${True}
        Update status    ${row}    ${SHEET_ID}    Bot workitem created: ID\=${output.id}
    END
