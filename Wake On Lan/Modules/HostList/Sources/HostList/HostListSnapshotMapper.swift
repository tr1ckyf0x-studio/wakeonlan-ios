import CoreData
import CoreDataService
import UIKit

protocol MapsSnapshotToHostListItem {

    typealias Snapshot = NSDiffableDataSourceSnapshot<String, HostListSectionItem>

    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> Snapshot
}

struct HostListSnapshotMapper: MapsSnapshotToHostListItem {

    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> Snapshot {
        let snapshotReference = snapshotReference as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        var snapshot = ContentSnapshot()

        snapshot.appendSections(snapshotReference.sectionIdentifiers)
        snapshot.sectionIdentifiers.forEach { (section: String) in
            let items = snapshotReference.itemIdentifiers(inSection: section)
                .compactMap { (managedObjectID: NSManagedObjectID) -> Host? in
                    context.object(with: managedObjectID) as? Host
                }
                .map { (host: Host) -> HostListCellViewModel in
                    HostListCellViewModel(
                        title: host.title,
                        iconName: host.iconName,
                        macAddress: host.macAddress
                    )
                }
                .map(HostListSectionItem.host)

            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }
}
