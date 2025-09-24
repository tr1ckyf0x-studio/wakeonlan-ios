import CoreData
import CoreDataService
import UIKit

protocol MapsSnapshotToHostListItem {
    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> HostListSnapshot
}

struct HostListSnapshotMapper: MapsSnapshotToHostListItem {

    func map(
        snapshotReference: NSDiffableDataSourceSnapshotReference,
        context: NSManagedObjectContext
    ) -> HostListSnapshot {
        let snapshotReference = snapshotReference as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        var snapshot = HostListSnapshot()

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
                        macAddress: host.macAddress,
                        createdAt: host.createdAt
                    )
                }
                .map(HostListSectionItem.host)

            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }
}
