//
//  HomeTableViewController.swift
//  Fetch Rewards
//
//  Created by Jason Cox on 10/10/20.
//

import UIKit

class HomeTableViewController: UITableViewController, ApiHiringFetchDelegate {

    // MARK: - Variables
    
    var arrayHiringData: [ApiHiringFetch.Hiring]?;
    var arraySectionTitles: [Int]?;
    
    // MARK: - General Functions
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Register any required cells
        self.tableView.register(UINib(nibName: "HiringTableViewCell", bundle: nil), forCellReuseIdentifier: "CellHiring");
        
        // TODO: Note - If this was a production app, I'd add in a full-screen overlay on top of the table view to indicate that the data load was happening in the background
        
        // TODO: Note - If this was a production app, I'd swap in a custom background view if the data load was not successfull OR if it was and there was no data returned
        
        // TODO: Idea - Grouping is very basic based on the provided spec; a more ideal style would be to only display `listId` on the first view and, when tapped, push to a second view that displays all the data OR to make each section expandable
        
        // Execute the fetch request
        let apiHiringFetch: ApiHiringFetch = ApiHiringFetch();
        apiHiringFetch.delegate = self;
        apiHiringFetch.sendRequest();
    }
    
    // MARK: - Data
    
    /// Filter the data to the specified IndexPath
    private func hiringData(for indexPath: IndexPath) -> ApiHiringFetch.Hiring? {
        return arrayHiringData?.filter({ $0.intListId == arraySectionTitles?[indexPath.section] })[indexPath.row];
    }
    
    // MARK: - Delegates
    
    func ApiHiringFetch_Complete(status: Api.Status, output: [ApiHiringFetch.Hiring]?) {
        // Check to see if the API request has completed successfully
        if (status == .Success) {
            // Filter out any blank or nil names (Requirement #3)
            arrayHiringData = output?.filter({ $0.stringName != "" && $0.stringName != nil });
            
            // Sort the data by listId (Requirement #2)
            arrayHiringData?.sort(by: { $0.intListId < $1.intListId });
            
            // Sort the data by name (Requirement #2)
            // - NOTE: Because `name` is type string, numeric inputs will be sorted as string, so ["1", "2", "100"] will sort as ["1", "100", "2"]
            arrayHiringData?.sort(by: { $0.stringName ?? "" < $1.stringName ?? "" });
            
            // Extract an array of section titles (Requirement #1)
            arraySectionTitles = Array(Set(arrayHiringData?.map({ $0.intListId }) ?? [])).sorted();
            
            // Reload the table view
            self.tableView.reloadData();
        } else {
            // Set a UIAlertController to output the error
            let alertController: UIAlertController = UIAlertController(title: "Fetch Error", message: "An error occured while trying to fetch the data", preferredStyle: .alert);
            
            // Add an OK button to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            
            // Show the alert controller
            self.present(alertController, animated: true, completion: nil);
        }
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HiringTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellHiring") as! HiringTableViewCell;
        
        // Extract the data for this cell
        let data: ApiHiringFetch.Hiring? = self.hiringData(for: indexPath);
        
        // Populate the cell
        cell.labelIdValue?.text = String(data?.intId ?? 0);
        cell.labelListIdValue?.text = String(data?.intListId ?? 0);
        cell.labelNameValue?.text = data?.stringName;
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHiringData?.filter({ $0.intListId == arraySectionTitles?[section] }).count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List ID \(String(arraySectionTitles?[section] ?? 0))";
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arraySectionTitles?.count ?? 0;
    }
}
